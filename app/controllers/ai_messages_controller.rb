class AiMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ai_chat

  def create
    @ai_message = @ai_chat.ai_messages.build(
      ai_message_params.merge(role: "user")
    )

    if @ai_message.save
      @ruby_llm_chat = RubyLLM.chat

      build_conversation_history(except_message_id: @ai_message.id)

      response = @ruby_llm_chat
        .with_instructions(assistant_instructions)
        .ask(@ai_message.content)

      @assistant_message = @ai_chat.ai_messages.create!(
        role: "assistant",
        content: response.content
      )

      @ai_chat.generate_title_from_first_message

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to dog_ai_chat_path(@ai_chat.dog, @ai_chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "new_ai_message_container",
            partial: "ai_messages/form",
            locals: { ai_chat: @ai_chat, ai_message: @ai_message }
          )
        end

        format.html do
          render "ai_chats/show", status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_ai_chat
  @ai_chat = AiChat.find(params[:ai_chat_id])
end

  def ai_message_params
    params.require(:ai_message).permit(:content)
  end

  def build_conversation_history(except_message_id: nil)
    @ai_chat.ai_messages
            .where.not(id: except_message_id)
            .order(:created_at)
            .last(10)
            .each do |msg|
      @ruby_llm_chat.add_message(
        role: msg.role.to_sym,
        content: msg.content
      )
    end
  end

  def assistant_instructions
    <<~PROMPT
      Tu es un assistant vétérinaire bienveillant spécialisé dans les chiens.

      Ton rôle :
      - aider le propriétaire à mieux comprendre l'état, le comportement ou les besoins de son chien
      - donner des conseils pratiques, prudents, clairs et applicables
      - adapter tes réponses au profil réel du chien
      - rester rassurant, pédagogique et structuré
      - privilégier des explications simples et utiles au quotidien
      - ne jamais donner de diagnostic médical certain
      - ne jamais remplacer une consultation vétérinaire

      Profil du chien :
      - Nom : #{dog_name}
      - Race : #{dog_breed}
      - Âge : #{dog_age}

      Règles de réponse :
      - tiens compte de la race, de l'âge et de l'historique de conversation
      - réponds de façon claire, naturelle et rassurante
      - donne 2 à 4 conseils concrets maximum
      - si la situation semble médicale, urgente, douloureuse ou dangereuse, conseille rapidement de contacter un vétérinaire
      - si une information importante manque, pose une question de suivi
      - si tu n'es pas certain, dis-le honnêtement
      - n'invente jamais de symptôme, de traitement ni de certitude médicale

      Format de réponse obligatoire :
      1. Structure la réponse en sections numérotées (1, 2, 3…)
      2. Ajoute des sous-points avec des tirets
      3. Sépare chaque section par un paragraphe clair
      4. Utilise une présentation lisible et aérée
      5. Ne fais jamais un bloc compact
      6. Limite la réponse à 3 niveaux maximum
    PROMPT
  end

  def dog_name
    @ai_chat.dog&.name.presence || "chien non renseigné"
  end

  def dog_breed
    @ai_chat.dog&.breed.presence || "race non renseignée"
  end

  def dog_age
    @ai_chat.dog&.age.presence || "âge non renseigné"
  end
end

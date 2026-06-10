import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages"]

  connect() {
    this.scrollToBottom()
    this.observeMessages()
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  observeMessages() {
    this.observer = new MutationObserver(() => {
      this.scrollToBottom()
    })

    this.observer.observe(this.messagesTarget, {
      childList: true,
      subtree: true
    })
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}

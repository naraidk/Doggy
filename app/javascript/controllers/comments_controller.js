import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { postId: String }

  connect() {
    this.element.classList.add("active")
    const card = document.getElementById(`post-card-${this.postIdValue}`)
    if (card) card.scrollIntoView({ behavior: "smooth", block: "start" })
  }

  prepare(event) {
    const postId = event.currentTarget.dataset.postId
    fetch(`/prepare_comment/${postId}`, { method: "POST" })
  }

  close() {
    this.element.classList.remove("active")
    setTimeout(() => {
      const frame = document.getElementById("comments_panel")
      if (frame) frame.innerHTML = ""
    }, 300)
  }
}

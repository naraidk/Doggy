import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { frameId: { type: String, default: "post_panel" } }

  connect() {
    this.element.classList.add("active")
  }

  close() {
    this.element.classList.remove("active")
    setTimeout(() => {
      const frame = document.getElementById(this.frameIdValue)
      if (frame) frame.innerHTML = ""
    }, 300)
  }
}

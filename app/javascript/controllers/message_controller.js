import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { dogId: Number }

  connect() {
    const currentDogId = parseInt(document.body.dataset.currentDogId || "0", 10)

    if (this.dogIdValue === currentDogId) {
      this.element.classList.add("sent")
      this.element.classList.remove("received")
    } else {
      this.element.classList.add("received")
      this.element.classList.remove("sent")
    }
  }
}

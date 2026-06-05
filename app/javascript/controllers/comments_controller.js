import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Active l’animation quand le contenu arrive
    this.element.classList.add("active")
  }

  close() {
    this.element.classList.remove("active")
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}

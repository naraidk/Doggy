import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { events: Array, iconUrl: String}

  connect() {
    this.loadLeaflet().then(() => this.initMap())
  }

  disconnect() {
    if (this.leafletMap) {
      this.leafletMap.remove()
      this.leafletMap = null
    }
  }

  async loadLeaflet() {
    if (window.L) return

    const css = document.createElement("link")
    css.rel = "stylesheet"
    css.href = "https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
    document.head.appendChild(css)

    return new Promise((resolve, reject) => {
      const script = document.createElement("script")
      script.src = "https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
      script.onload = resolve
      script.onerror = reject
      document.head.appendChild(script)
    })
  }

  initMap() {
    this.leafletMap = L.map(this.element).setView([46.2276, 2.2137], 6)

   L.tileLayer("https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png", {
  attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">Doggy</a>',
  maxZoom: 19
}).addTo(this.leafletMap)

    this.addEventMarkers()
  }

  addEventMarkers() {
    // 1. On change L.divIcon par L.icon pour charger ton fichier SVG
    const doggyIcon = L.icon({
      iconUrl: this.iconUrlValue, // Récupère le SVG envoyé par index.html.erb
      iconSize: [36, 36],         // Taille d'affichage de ton SVG
      iconAnchor: [18, 18],       // Centre le SVG sur la carte
      popupAnchor: [0, -18]       // Positionne la bulle d'infos juste au-dessus
    })

    this.eventsValue.forEach(event => {
      L.marker([event.latitude, event.longitude], { icon: doggyIcon })
        .addTo(this.leafletMap)
        .bindPopup(`
          <div class="map-popup">
            <strong>${event.title}</strong><br>
            <span class="text-muted small">${event.city} · ${event.date}</span><br>
            <a href="${event.url}" class="btn btn-sm btn-primary mt-1">Voir l'événement</a>
          </div>
        `)
    })
  }
}

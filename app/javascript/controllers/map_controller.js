import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { events: Array }

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

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '© <a href="https://www.openstreetmap.org/copyright">Doggy</a>',
      maxZoom: 19
    }).addTo(this.leafletMap)

    this.addEventMarkers()
  }

  addEventMarkers() {
    const pawIcon = L.divIcon({
      html: `<div class="paw-marker">🐾</div>`,
      className: "",
      iconSize: [36, 36],
      iconAnchor: [18, 36],
      popupAnchor: [0, -36]
    })

    this.eventsValue.forEach(event => {
      L.marker([event.latitude, event.longitude], { icon: pawIcon })
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

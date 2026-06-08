import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // 1. On déclare la cible geocoder pour ton index.html.erb
  static targets = [ "geocoder" ]

  static values = {
    events: Array,
    iconUrl: String
  }

  connect() {
    // On attend que Leaflet ET le géocodeur soient chargés avant d'initialiser
    this.loadLeaflet().then(() => this.initMap())
  }

  disconnect() {
    if (this.leafletMap) {
      this.leafletMap.remove()
      this.leafletMap = null
    }
  }

  async loadLeaflet() {
    if (window.L && window.L.Control.Geocoder) return

    // Injection du CSS Leaflet standard (déjà présent dans ton code)
    if (!document.querySelector('link[href*="leaflet@1.9.4"]')) {
      const css = document.createElement("link")
      css.rel = "stylesheet"
      css.href = "https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
      document.head.appendChild(css)
    }

    // --- NOUVEAU : Injection du CSS du Géocodeur ---
    const geocoderCss = document.createElement("link")
    geocoderCss.rel = "stylesheet"
    geocoderCss.href = "https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.css"
    document.head.appendChild(geocoderCss)

    // Chargement des scripts JS l'un après l'autre (Promesses chaînées)
    return new Promise((resolve, reject) => {
      if (window.L) {
        this.loadGeocoderScript().then(resolve)
      } else {
        const script = document.createElement("script")
        script.src = "https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
        script.onload = () => {
          this.loadGeocoderScript().then(resolve)
        }
        script.onerror = reject
        document.head.appendChild(script)
      }
    })
  }

  // Petite méthode utilitaire pour charger le script du géocodeur une fois que "L" existe
  loadGeocoderScript() {
    return new Promise((resolve, reject) => {
      if (window.L.Control.Geocoder) {
        resolve()
      } else {
        const geocoderScript = document.createElement("script")
        geocoderScript.src = "https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.js"
        geocoderScript.onload = resolve
        geocoderScript.onerror = reject
        document.head.appendChild(geocoderScript)
      }
    })
  }

  initMap() {
    this.leafletMap = L.map('map').setView([46.2276, 2.2137], 6)

    L.tileLayer("https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png", {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      maxZoom: 19
    }).addTo(this.leafletMap)

    // --- NOUVEAU : Configuration et branchement de la barre de recherche ---
    const geocoderControl = L.Control.geocoder({
      defaultMarkGeocode: false,
      placeholder: "Trouver un événement...",
      autoComplete: true,      // Active l'autocomplétion
      suggestTimeout: 300,
    })

    geocoderControl.on('markgeocode', (e) => {
      const bbox = e.geocode.bbox
      const poly = L.polygon([
        bbox.getSouthEast(),
        bbox.getNorthEast(),
        bbox.getNorthWest(),
        bbox.getSouthWest()
      ])
      this.leafletMap.fitBounds(poly.getBounds())
    })

    // On injecte le bloc HTML de recherche dans ta div cible si elle est présente (sur ton index)
    if (this.hasGeocoderTarget) {
      const container = geocoderControl.onAdd(this.leafletMap)
      this.geocoderTarget.appendChild(container)
    }

    this.addEventMarkers()
  }

  addEventMarkers() {
    // 1. On change L.divIcon par L.icon pour charger ton fichier SVG
    const doggyIcon = L.icon({
      iconUrl: this.iconUrlValue, // Récupère le SVG envoyé par index.html.erb
      iconSize: [36, 36],         // Taille d'affichage de ton SVG
      iconAnchor: [18, 36],       // Centre le SVG sur la carte
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

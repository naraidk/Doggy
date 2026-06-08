import { Controller } from "@hotwired/stimulus"

let mapboxLoadPromise = null
let geocoderLoadPromise = null

export default class extends Controller {
  static values = { events: Array, token: String }
  static targets = ["geocoder", "container"]

  connect() {
    this.active = true
    this.beforeCacheHandler = () => this.cleanup()
    document.addEventListener("turbo:before-cache", this.beforeCacheHandler)
    this.loadMapbox()
      .then(() => this.loadGeocoder())
      .then(() => { if (this.active) this.initMap() })
  }

  disconnect() {
    this.active = false
    document.removeEventListener("turbo:before-cache", this.beforeCacheHandler)
    this.cleanup()
  }

  cleanup() {
    if (this.map) {
      this.map.remove()
      this.map = null
    }
  }

  loadMapbox() {
    if (window.mapboxgl) return Promise.resolve()
    if (mapboxLoadPromise) return mapboxLoadPromise

    const css = document.createElement("link")
    css.rel = "stylesheet"
    css.href = "https://api.mapbox.com/mapbox-gl-js/v3.4.0/mapbox-gl.css"
    document.head.appendChild(css)

    mapboxLoadPromise = new Promise((resolve, reject) => {
      const script = document.createElement("script")
      script.src = "https://api.mapbox.com/mapbox-gl-js/v3.4.0/mapbox-gl.js"
      script.onload = resolve
      script.onerror = reject
      document.head.appendChild(script)
    })

    return mapboxLoadPromise
  }

  loadGeocoder() {
    if (window.MapboxGeocoder) return Promise.resolve()
    if (geocoderLoadPromise) return geocoderLoadPromise

    const css = document.createElement("link")
    css.rel = "stylesheet"
    css.href = "https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v5.0.0/mapbox-gl-geocoder.css"
    document.head.appendChild(css)

    geocoderLoadPromise = new Promise((resolve, reject) => {
      const script = document.createElement("script")
      script.src = "https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v5.0.0/mapbox-gl-geocoder.min.js"
      script.onload = resolve
      script.onerror = reject
      document.head.appendChild(script)
    })

    return geocoderLoadPromise
  }

  initMap() {
    if (this.map) return

    mapboxgl.accessToken = this.tokenValue

    this.map = new mapboxgl.Map({
      container: this.containerTarget,
      style: "mapbox://styles/mapbox/streets-v12",
      center: [2.2137, 46.2276],
      zoom: 5
    })

    this.map.addControl(new mapboxgl.NavigationControl())

    const geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      placeholder: "Rechercher un lieu...",
      language: "fr"
    })
    this.geocoderTarget.appendChild(geocoder.onAdd(this.map))

    this.map.on("load", () => this.addEventMarkers())
  }

  addEventMarkers() {
    this.eventsValue.forEach(event => {
      const el = document.createElement("div")
      el.className = "paw-marker"
      el.textContent = "🐾"

      const popup = new mapboxgl.Popup({ offset: 25 }).setHTML(`
        <div class="map-popup">
          <strong>${event.title}</strong><br>
          <span class="text-muted small">${event.city} · ${event.date}</span><br>
          <a href="${event.url}" class="btn btn-sm btn-primary mt-1">Voir l'événement</a>
        </div>
      `)

      new mapboxgl.Marker({ element: el })
        .setLngLat([event.longitude, event.latitude])
        .setPopup(popup)
        .addTo(this.map)
    })
  }
}

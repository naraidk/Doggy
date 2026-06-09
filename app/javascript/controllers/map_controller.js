import { Controller } from "@hotwired/stimulus"

let mapboxLoadPromise = null
let geocoderLoadPromise = null

export default class extends Controller {
// Remplace ta ligne actuelle par celle-ci :
  static values = { events: Array, token: String, iconUrl: String }
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

    // 1. Par défaut, on définit le centre sur la France avec un zoom global
    let mapCenter = [2.2137, 46.2276]
    let mapZoom = 5

    // 2. Si on est sur la page "show" (il n'y a qu'un seul événement dans le tableau)
    if (this.eventsValue.length === 1) {
      const singleEvent = this.eventsValue[0]
      // Mapbox attend [longitude, latitude]
      mapCenter = [singleEvent.longitude, singleEvent.latitude]
      mapZoom = 13 // Un zoom à 13 est idéal pour voir la ville et les rues principales
    }

    // 3. Initialisation de la carte avec les coordonnées dynamiques
    this.map = new mapboxgl.Map({
      container: this.containerTarget,
      style: "mapbox://styles/mapbox/light-v11", // Ta superbe carte épurée blanche
      center: mapCenter,
      zoom: mapZoom
    })

    this.map.addControl(new mapboxgl.NavigationControl())

    // Si tu as gardé le geocoder (uniquement utile sur l'index, optionnel sur la show)
    if (this.hasGeocoderTarget) {
      const geocoder = new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        mapboxgl: mapboxgl,
        placeholder: "Rechercher un lieu...",
        language: "fr"
      })
      this.geocoderTarget.appendChild(geocoder.onAdd(this.map))
    }

    this.map.on("load", () => this.addEventMarkers())
  }

  addEventMarkers() {
    this.eventsValue.forEach(event => {
      const el = document.createElement("div")
      el.className = "paw-marker"

      // C'est ici qu'on utilise la variable magique qui contient l'adresse du SVG !
      el.style.backgroundImage = `url(${this.iconUrlValue})`

      // On donne une taille fixe à ton picto pour qu'il apparaisse proprement
      el.style.width = "36px"
      el.style.height = "36px"
      el.style.backgroundSize = "contain"
      el.style.backgroundRepeat = "no-repeat"
      el.style.backgroundPosition = "center"
      el.style.cursor = "pointer"

      const popup = new mapboxgl.Popup({ offset: 25 }).setHTML(`
        <div class="map-popup">
          <strong>${event.title}</strong><br>
          <span class="text-muted small">${event.city} · ${event.date}</span><br>
        </div>
      `)

      new mapboxgl.Marker({ element: el })
        .setLngLat([event.longitude, event.latitude])
        .setPopup(popup)
        .addTo(this.map)
    })
  }
}

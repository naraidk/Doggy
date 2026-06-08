// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

// --- CONFIGURATION DE SWEETALERT2 POUR TURBO ---
document.addEventListener("turbo:load", () => {
  // On s'assure que Turbo est bien chargé globalement avant d'intercepter
  if (window.Turbo) {
    window.Turbo.setConfirmMethod((message, element) => {
      return new Promise((resolve) => {
        Swal.fire({
          // title: 'Attention !',
          text: message,
          // icon: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#FF5D24', // Ton orange Doggy !
          cancelButtonColor: '#adb5bd',  // Gris neutre
          confirmButtonText: 'Oui, supprimer !',
          cancelButtonText: 'Annuler',
          background: '#ffffff',
          customClass: {
            popup: 'rounded-5' // Assorti aux arrondis de ton application
          }
        }).then((result) => {
          // Renvoie true à Turbo si l'utilisateur a confirmé la modale
          resolve(result.isConfirmed)
        })
      })
    })
  }
})

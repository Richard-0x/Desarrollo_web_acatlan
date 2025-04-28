// Scroll subir_pagina 

    
      window.onscroll = function () {
        var btn = document.getElementById("btnScrollTop");
        if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
          btn.style.display = "block";
        } else {
          btn.style.display = "none";
        }
      };
    
      function scrollToTop() {
        window.scrollTo({ top: 0, behavior: "smooth" });
      }
   
// Cambiar imagenes

var images = [
    "../Pagina_Principal/Imagenes_Principal_pag/reactor 14.JPG",
    "../Pagina_Principal/Imagenes_Principal_pag/reactor_12.JPG",
    "../Pagina_Principal/Imagenes_Principal_pag/muestras.JPG",
    "../Pagina_Principal/Imagenes_Principal_pag/muestras1.JPG"
  ];

  var currentImageIndex = 0; // empezamos desde la primera imagen

  function changeImage() {
    var image = document.getElementById("myImage");

    // Cambiar al siguiente índice
    currentImageIndex++;

    // Si llegamos al final, volvemos al inicio
    if (currentImageIndex >= images.length) {
      currentImageIndex = 0;
    }
    image.src = images[currentImageIndex];
  }

  
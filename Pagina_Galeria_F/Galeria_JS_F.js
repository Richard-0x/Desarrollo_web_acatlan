document.addEventListener("DOMContentLoaded", function() {
    const galleryItems = document.querySelectorAll(".gallery-item img");
    const lightbox = document.getElementById("lightbox");
    const lightboxImg = document.getElementById("lightbox-img");
    const closeBtn = document.querySelector(".close");
    let currentIndex = 0;

    galleryItems.forEach((item, index) => {
        item.addEventListener("click", function() {
            currentIndex = index;
            lightbox.style.display = "block";
            lightboxImg.src = this.src;
        });
    });

    closeBtn.addEventListener("click", function() {
        lightbox.style.display = "none";
    });

    lightbox.addEventListener("click", function(e) {
        if (e.target !== lightboxImg) {
            lightbox.style.display = "none";
        }
    });

    // Navegación con teclado
    document.addEventListener("keydown", function(e) {
        if (lightbox.style.display === "block") {
            if (e.key === "ArrowLeft" && currentIndex > 0) {
                currentIndex--;
                lightboxImg.src = galleryItems[currentIndex].src;
            } else if (e.key === "ArrowRight" && currentIndex < galleryItems.length - 1) {
                currentIndex++;
                lightboxImg.src = galleryItems[currentIndex].src;
            }
        }
    });
});
const swiper = new Swiper('.swiper-container', {
    loop: true,
    effect: 'coverflow', // Efecto de coverflow
    grabCursor: true,
    centeredSlides: true,
    slidesPerView: 'auto',
    coverflowEffect: {
        rotate: 50,
        stretch: 0,
        depth: 100,
        modifier: 1,
        slideShadows: true,
    },
    speed: 1000,
    navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
    },
});


/**
 * Sana Landing Page - Main Logic
 * Optimized for performance and clean architecture
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Initialize AOS (Animate On Scroll)
    if (typeof AOS !== 'undefined') {
        AOS.init({
            duration: 800,
            once: true,
            easing: 'ease-out-back'
        });
    }

    // 2. Interactive Showcase Switcher
    // Links feature list hover items with the screens wall grid
    const featureItems = document.querySelectorAll('.feature-item');
    const wallItems = document.querySelectorAll('.wall-item');

    if (featureItems.length && wallItems.length) {
        featureItems.forEach((item, index) => {
            item.addEventListener('mouseenter', () => {
                // Remove active class from all features and wall items
                featureItems.forEach(f => f.classList.remove('active'));
                wallItems.forEach(w => w.classList.remove('active'));

                // Add active class to current feature and corresponding wall item
                item.classList.add('active');
                
                // We use data-id to match (1-indexed)
                const wallItem = document.querySelector(`.wall-item[data-id="${index + 1}"]`);
                if (wallItem) {
                    wallItem.classList.add('active');
                    
                    // Smooth scroll to the wall item if needed on mobile
                    if (window.innerWidth < 768) {
                        wallItem.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                }
            });
        });
    }

    // 3. Navbar Background Scroll Effect
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.classList.add('navbar--scrolled');
        } else {
            navbar.classList.remove('navbar--scrolled');
        }
    });
});

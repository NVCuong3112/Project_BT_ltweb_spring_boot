/* script.js — Library Manager */

/* Xác nhận xóa danh mục */
function confirmDelete(id) {
    if (confirm("Bạn có chắc chắn muốn xóa danh mục này?")) {
        window.location.href = "delete-category?id=" + id;
    }
}

/* Mobile menu toggle */
function toggleMenu() {
    var menu = document.querySelector('.navbar-menu');
    if (menu) {
        menu.classList.toggle('active');
    }
}

/* Close mobile menu when clicking outside */
document.addEventListener('click', function(e) {
    var menu = document.querySelector('.navbar-menu');
    var toggle = document.querySelector('.navbar-toggle');
    if (menu && toggle && !menu.contains(e.target) && !toggle.contains(e.target)) {
        menu.classList.remove('active');
    }
});

export function setupNavbarItemMatchRoute() {
  let navItems = $('.navbar-kindmate .navbar-nav--left .nav-item')
  navItems.each(function (index, el) {
    let navLink = el.querySelector('.nav-link')
    let currentRoute = window.location.pathname
    if (currentRoute.includes(navLink.getAttribute('href'))) {
      el.classList.add('active')
    }
  })
}

export function setupPaymentRadio() {
  $('.payment-box').click(function (event) {
    event.preventDefault()

    let currentActive = $('.payment-box.active')
    currentActive.removeClass('active')
    currentActive.find('input').removeAttr('checked')

    this.classList.add('active')
    this.querySelector('input').setAttribute('checked', 'checked')
  })
}

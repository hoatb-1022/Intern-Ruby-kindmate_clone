export function setupPaymentRadio() {
  $('.payment-box').click(function (event) {
    event.preventDefault()

    $('.payment-box.active').removeClass('active')
    this.classList.add('active')
  })
}

export function setupPaymentRadio() {
  $('.payment-box').click(function (event) {
    $('.payment-box.active').removeClass('active')
    this.classList.add('active')
  })
}

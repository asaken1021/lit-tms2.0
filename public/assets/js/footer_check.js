function checkFooter() {
  console.log('^q^');
  let a = $('.footer');
  let p = a.offset().top - $(window).height() + a.height() + parseInt($('.footer').css('padding-top').substring(0, 2)) + parseInt($('.footer').css('margin--top').substring(0, 2));
  if (p < 0) {
    a.css({ 'position': 'fixed', 'bottom': '0px', 'width': '100%' });
  }
}
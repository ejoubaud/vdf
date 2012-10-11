# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(".picto img").hover(
    ->
      $i=$(this)
      pos = $i.position()
      unless $tip = $i.data('tip')
        $tip = $ """
          <div class='tooltip'>
            <h3>#{ $i.prop 'alt' }</h3>
            <p>#{ $i.data 'longdesc' }</p>
          </div>
          """
        $tip.hide()
        $i.after $tip
      $tip.show()
      coord = {
        left:   pos.left + $i.width();
        top:    pos.top
        'min-height': $i.closest('li').height() - ($tip.innerHeight() - $tip.height());
      }
      $tip.css(coord)
      $i.data('tip', $tip)
    , ->
      $(this).data('tip').fadeOut(200)
  )


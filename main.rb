require 'gtk2'
window = Gtk::Window.new
window.set_default_size(800, 600)
window.show

window.signal_connect("destroy") {
  puts "destroy event occurred"
  Gtk.main_quit
}

Gtk.main
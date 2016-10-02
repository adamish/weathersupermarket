require 'RMagick'

include Magick

def get_images()
  Dir.glob("img/**/*.png")
end

def css(filename)
  if m = /img\/(.*)\/(.*).png/.match(filename)
    "#{m[1]}-#{m[2]}"
  elsif m = /img\/(.*).png/.match(filename)
    "#{m[1]}"
  end
end

cat = Image.new(4000, 1000) do
  self.background_color= "transparent"
end
cat.alpha(Magick::ActivateAlphaChannel)
x = 0
y = 0
max_height = 0
css_output = ""
images = get_images().sort.select do |it|
  !(it.include?("favicon.png") || it.include?("sprite.png") || it.include?("search.png"))
end

css_classes = Array.new
images.each do |f|
  img = Magick::Image::read(f)[0]
  img.alpha(Magick::ActivateAlphaChannel)
  width = img.columns
  height = img.rows
  cat.composite!(img, x, y, Magick::OverCompositeOp)
  css_output = css_output + ".#{css(f)} {\n"
  css_output = css_output + "  background-position: -#{x}px 0;\n"

  css_output = css_output + "}\n"

  css_classes.push("." + css(f))
  x = x + width
  y = 0
  max_height = [max_height, height].max
end
css_output = css_output + "#{css_classes.join(',')} {\n background-image: url(\"/img/sprite.png\");\n}\n"

File.write('sprite.css', css_output)
cat.crop!(0, 0, x, max_height)
list = ImageList.new
list.push cat
list.write("png:img/sprite.png")


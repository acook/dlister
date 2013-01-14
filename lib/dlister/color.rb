module Dlister
  module Color
    def bright name
      fg name, :bright
    end

    def normal name = nil
      if name then
        fg name, :normal
      else
        esc 0
      end
    end

    def fg name, style_name = :normal
      esc style(style_name), "3#{color(name)}"
    end

    def bg name, style_name = :normal
      esc style(style_name), "4#{color(name)}"
    end

    def style name
      [
        :normal,
        :bright,
        :underlined
      ].index name
    end

    def color name
      [
        :black,
        :red,
        :green,
        :yellow,
        :blue,
        :magenta,
        :cyan,
        :white
      ].index name
    end

    def esc *code
      "\e[#{code.compact.join(';')}m"
    end

    def console_width
      tiocgwinsz = 0x40087468
      str = [0, 0, 0, 0].pack('SSSS')
      if STDOUT.ioctl(tiocgwinsz, str) >= 0 then
        str.unpack('SSSS')[1]
      else
        1.0 / 0
      end
    end
  end
end

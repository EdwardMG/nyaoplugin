fu! s:setup()
ruby << RUBY
require 'fileutils'

module NyaoPlugin
  @@opt_path = "#{ENV["HOME"]}/.vim/pack/eg/opt"

  def self.new_plugin name
    path = "#{@@opt_path}/#{to_snake name}/plugin"
    FileUtils.mkdir_p path
    fp = "#{path}/#{to_snake name}.vim"
    File.write(fp, template(name))
    Ex.edit fp
    Ex.cd "#{@@opt_path}/#{to_snake name}"
    `git init && git add .`
  end

  def self.template name
    <<~TEMPLATE
    fu! s:setup()
    ruby << RUBY
    module #{to_pascal name}
    end
    RUBY
    endfu

    call s:setup()
    TEMPLATE
  end

  def self.to_pascal str
    str.split(/[-_ ]/).map(&:capitalize).join('')
  end

  def self.to_snake str
    str.split(/[- ]/).map(&:downcase).join('_')
  end
end
RUBY
endfu

call s:setup()

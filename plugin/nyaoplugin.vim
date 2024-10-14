fu! s:setup()
ruby << RUBY
require 'fileutils'

module NyaoPlugin
  @@opt_path = "#{ENV["HOME"]}/.vim/pack/eg/opt"

  def self.new_plugin name
    path = "#{@@opt_path}/#{to_snake name}/plugin"
    doc_path = "#{@@opt_path}/#{to_snake name}/doc"
    FileUtils.mkdir_p path
    FileUtils.mkdir_p doc_path
    fp     = "#{path}/#{to_snake name}.vim"
    doc_fp = "#{doc_path}/#{to_snake name}.txt"
    File.write(fp, template(name))
    File.write(doc_fp, doc_template(name))
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

    doc_path = Ev.expand('<sfile>:h:h') + 'doc/'
    Ex['silent! exe "helptags '+doc_path+'"']
    RUBY
    endfu

    call s:setup()
    TEMPLATE
  end

  def self.doc_template name
    <<~TEMPLATE
    *#{to_snake name}*

    INTRODUCTION

    Requires rubywrapper plugin.

    USAGE

    <Commands>

    <Functions>

    vim:autoindent noexpandtab tabstop=8 shiftwidth=8
    vim:se modifiable
    vim:tw=78:et:ft=help:norl:
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

nno \N :ruby NyaoPlugin.new_plugin(Ev.input("plugin name: "))<CR>

call s:setup()

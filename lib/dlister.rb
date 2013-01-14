require "dlister/version"

module Dlister
  module_function

  def list path
    `ls #{path}`
  end
end

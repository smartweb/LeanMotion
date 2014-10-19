module LeanMotion

  def self.run(function_name, params, &block)
    AVCloud.callFunctionInBackground(function_name, withParameters:params, block:lambda do |object, error|
        block.call(object, error)
    end)
  end
  
end

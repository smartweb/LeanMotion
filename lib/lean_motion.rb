unless defined?(Motion::Project::Config)
  raise "The lean_motion gem must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  core_lib = File.join(File.dirname(__FILE__), 'lean_motion')
  insert_point = app.files.find_index { |file| file =~ /^(?:\.\/)?app\// } || 0

  Dir.glob(File.join(core_lib, '**/*.rb')).reverse.each do |file|
    app.files.insert(insert_point, file)
  end

  app.vendor_project('vendor/AVOSCloud.framework', 
                      :static, 
                      :products => ['AVOSCloud'], 
                      :headers_dir => 'Headers')
end

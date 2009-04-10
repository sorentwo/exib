require 'rake'
require 'time'

DELIVERABLE_DIR     = 'deliver'
DELIVERABLES        = %w(assets deploy doc/HOTKEYS.txt)
ARCHIVE_BASENAME    = ENV['BASE'] || 'deliverable' 
ARCHIVE_EXTENSION   = ENV['EXT']  || 'zip'
ARCHIVE_DATE_STRING = ENV['DATE'] || '%Y.%m.%d.%H%M'

task :default => :test

task(:test) {}

# Exib Tasks  ------------------------------------------------------------------

namespace :exib do
  desc "Automatically embed files and compile the MXML file into a SWF"
  task :compile => [ :auto_embed, :compile_mxml]
  
  desc "Packages the necessary files into a deliverable archive"
  task :package do
    archive_name = "#{ARCHIVE_BASENAME}_#{Time.now.strftime(ARCHIVE_DATE_STRING)}.#{ARCHIVE_EXTENSION}"
    sh %{7za a -mx=9 -mmt=on #{File.join(DELIVERABLE_DIR, archive_name)} #{DELIVERABLES.join}}
  end
  
  desc "Upload the most recent deliverable to a server. Before using this task \
        connection options must be set up in this rakefile"
  task :deliver do
  end
end

# Compile Tasks ----------------------------------------------------------------
task :auto_embed do
end

task :compile_mxml do
  mxmlc_bin    = '/opt/flex/bin/mxmlc'
  source_paths = ['~/Work/Code/EXIB/source', '/Applications/Adobe\ Flash\ CS4/Common/Configuration/ActionScript\ 3.0/projects/Flash/src/']
  mxml_file    = sh %{find ./source -name '*.mxml'}
  
  sh %{#{mxmlc_bin} -use-network=false -compiler.source-path=#{source_paths.join(',')} #{mxml_file}}
end
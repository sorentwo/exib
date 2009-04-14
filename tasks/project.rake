require 'rake'
require 'time'

DELIVERABLE_DIR    = 'deliver'
DELIVERABLES       = %w(assets deploy doc/HOTKEYS.txt)
ARCHIVE_BASENAME   = ENV['BASE'] || 'deliverable' 
ARCHIVE_EXTENSION  = ENV['EXT']  || 'zip'
ARCHIVE_DATE       = ENV['DATE'] || '%Y.%m.%d.%H%M'

project_path = File.expand_path(File.basename(__FILE__))
project_name = File.basename(File.dirname(File.expand_path(__FILE__))).gsub(/\/(.?)/) { "::" + $1.upcase}.gsub(/(^|_)(.)/) { $2.upcase }

# Exib Tasks  ------------------------------------------------------------------

namespace :exib do
  
  task :default => [:compile, :open]
  
  desc "Compile the EXIB Application to SWF"
  task :compile do
    mxmlc_bin    = '/opt/flex/bin/mxmlc'
    source_paths = ['/Users/parker/Work/Code/EXIB/source', '/Applications/Adobe\ Flash\ CS4/Common/Configuration/ActionScript\ 3.0/projects/Flash/src/']
    exib_app     = "source/#{project_name}.as"

    sh %{#{mxmlc_bin} -use-network=false -compiler.source-path=#{source_paths.join(',')} #{exib_app}}
  end
  
  desc "Open the compiled EXIB Application"
  task :open do
    sh %{open source/#{project_name}.swf -a '/Applications/Flash\ Player.app'}
  end
  
  desc "Automatically embed files listed in .exml into the source .as"
  task :embed do
  end
  
  desc "Packages the necessary files into a deliverable archive"
  task :package do
    archive_name = "#{ARCHIVE_BASENAME}_#{Time.now.strftime(ARCHIVE_DATE_STRING)}.#{ARCHIVE_EXTENSION}"
    sh %{7za a -mx=9 -mmt=on #{File.join(DELIVERABLE_DIR, archive_name)} #{DELIVERABLES.join}}
  end
end
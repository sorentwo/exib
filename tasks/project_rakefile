require 'rake'
require 'time'

DELIVERABLE_DIR     = 'deliver'
DELIVERABLES        = %w(assets deploy doc/HOTKEYS.txt)
ARCHIVE_BASENAME    = ENV['BASE'] || 'deliverable' 
ARCHIVE_EXTENSION   = ENV['EXT']  || 'zip'
ARCHIVE_DATE_STRING = ENV['DATE'] || '%Y.%m.%d.%H%M'

REMOTE_LOGIN  = ENV['REMOTE_LOGIN']  || 'parkerselbert'
REMOTE_SERVER = ENV['REMOTE_SERVER'] || 'greytwo.com'
REMOTE_PATH   = ENV['REMOTE_PATH']   || '~/work/WPALPHA'

task :default => :test

task(:test) {}

# Exib Tasks  ------------------------------------------------------------------

namespace :project do
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

# Source Tasks -----------------------------------------------------------------

namespace :source do
  desc "Sync the source to the external server"
  task :backup do
    path = "#{REMOTE_LOGIN}@#{REMOTE_SERVER}:#{REMOTE_PATH}"
    sh %{rsync -cav --progress --del -e 'ssh' ./* #{path}}
  end
end

private

def random_password(size = 8)
  chars = (('a'..'z').to_a + ('0'..'9').to_a) + %w(_-$%) - %w(i o 0 1 l O)
  (1..size).map{|a| chars[rand(chars.size)] }.join
end
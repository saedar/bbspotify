require 'json'

class BBSpotify

  # Add doc
  def initialize(source, changes)
    @source = JSON.parse(source) # Maybe I update this to just be the output var and not have a separate one.
    @changes = JSON.parse(changes)
    @output = @source
  end

  # Add doc
  def process
    @changes.keys.each do |k|
      case k
      when 'add_song'
        add_song(@changes[k])
      when 'new_playlist'
        new_playlist(@changes[k])
      when 'remove_playlist'
        remove_playlist(@changes[k])
      end
    end

    puts @output['playlists'] # Update to output a file.
  end

  # Add doc
  def new_playlist(playlists)
    playlists.each do |p|
      next if p['owner_id'].nil?
      next if p['song_ids'].nil?

      next if @source['users'].find { |u| u['id'] == p['owner_id'] }.nil?

      playlist = { 'id' => @source['playlists'].last['id'].to_i + 1, 'owner_id' => p['owner_id'], 'song_ids' => [] } # Need a better id pattern to handle deletes.

      p['song_ids'].each do |s|
        playlist['song_ids'].push(s) unless @source['songs'].find { |song| song['id'] == s }.nil?
      end

      @output['playlists'].push(playlist) unless playlist['song_ids'].empty?
    end
  end

  # Add doc
  def add_song(songs)
    songs.each do |s|
      next if s['song_id'].nil?
      next if s['playlist_id'].nil?

      source_song = @source['songs'].find { |source_song| source_song['id'] == s['song_id'] }
      source_playlist = @source['playlists'].find { |p| p['id'] == s['playlist_id'] }

      next if source_song.nil?
      next if source_playlist.nil?
      next if @source['playlists'].find { |p| p['id'] == s['playlist_id'] }['song_ids'].include? s['song_id']

      playlist_index = @output['playlists'].index { |p| p['id'] == source_playlist['id'] }
      @output['playlists'][playlist_index]['song_ids'].concat([s['song_id']])
    end
  end

  # Add doc
  def remove_playlist(ids)
    ids.each do |id|
      @output["playlists"].delete_if { |p| p['id'] == id }  
    end
  end

end
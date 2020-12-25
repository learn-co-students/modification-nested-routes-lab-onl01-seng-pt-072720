class SongsController < ApplicationController
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = @artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: "Song not found"
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    if params[:artist_id] && !Artist.exists?(params[:artist_id])
      redirect_to artists_path, alert: "Artist not found."
    else
      @song = Song.new(artist_id: params[:artist_id])
    end
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    if params[:artist_id] # Here we're looking for the existence of params[:artist_id], which we know would come from our nested route.
      artist = Artist.find_by(id: params[:artist_id]) 
      if artist.nil? # If it's there, we want to make sure that we find a valid artist.
        redirect_to artists_path, alert: "Artist not found." # If we can't, we redirect them to the artists_path with a flash[:alert].
      else
        @song = artist.songs.find_by(id: params[:id]) # If we do find the artist, we next want to find the song by params[:id], but, instead of directly looking for Song.find(), we need to filter the query through our artist.songs collection to make sure we find it in that artist's songs. It may be a valid song id, but it might not belong to that artist, which makes this an invalid request.
        redirect_to artist_songs_path(artist), alert: "song not found." if @song.nil?
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end
end


class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index 
    session[:sort] = params[:sort] if params[:sort]
    session[:ratings] = params[:ratings] if params[:ratings]
    
    if (!params[:ratings] || !params[:sort]) && session[:ratings] && session[:sort]
      flash.keep
      redirect_to movies_path :ratings => session[:ratings], :sort => session[:sort] and return
    elsif !params[:ratings] && session[:ratings]
      flash.keep
      redirect_to movies_path :ratings => session[:ratings] and return
    elsif !params[:sort] && session[:sort]
      flash.keep
      redirect_to movies_path :sort => session[:sort] and return
    end

    @all_ratings = Movie.ratings

    @checked_ratings = params[:ratings] ? params[:ratings].keys : @all_ratings
    @all_ratings = Movie.ratings
    if params[:sort] == "title"
      @movies = Movie.where(:rating => @checked_ratings).sort_by(&:title)
      @title_sorted = 'hilite'
    elsif params[:sort] == "date"
      @movies = Movie.where(:rating => @checked_ratings).sort_by(&:release_date)
      @date_sorted = 'hilite'
    else
      @movies = Movie.where(:rating => @checked_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

import { getUnprocessedMovies, insertMovieDetails } from "./db.js"
import { getMovieDetails } from "./openapi.js"
import type { ScrappedMovie } from "./scrapeMoviesList.js"

export type MovieDetails = {
  id: string
  scrapedMovieId: string
  title: string
  director: string
  year: number
  group: string
  /** YYYY/MM/DD HH:MM 24 hours format string */
  when: string
  summary: string
  imageURL: string
  moreInfoURL: string
}

export const fillMoviesDetails = async () => {
  const unprocessed = getUnprocessedMovies()
  console.log(`Found ${unprocessed.length} unprocessed movies`)
  for (const movie of unprocessed) {
    const details = await fillMovieDetails(movie)
    insertMovieDetails(details)
  }
  console.log(`Filled ${unprocessed.length} movies details`)
}

const fillMovieDetails = async (movie: ScrappedMovie): Promise<Omit<MovieDetails, 'id'>> => {
  const details = await getMovieDetails(movie)
  
  return {
    scrapedMovieId: movie.id,
    imageURL: movie.imageURL,
    moreInfoURL: movie.moreInfoURL,

    ...details,
  }
}

fillMoviesDetails()
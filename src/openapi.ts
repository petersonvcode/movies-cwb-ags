import OpenAI from "openai";
import fs from 'fs';
import type { ScrappedMovie } from "./scrapeMoviesList.js";

let client: OpenAI | null = null;
const model = 'gpt-4.1-nano'

const getClient = () => {
  if (!client) {
    const apiKey = getOpenApiToken()
    client = new OpenAI({ apiKey });
  }
  return client;
}

const getOpenApiToken = () => {
  const content = fs.readFileSync('.env', 'utf8')
  const parsed = JSON.parse(content)
  return parsed.openApiToken
}

export const getMovieDetails = async (movie: ScrappedMovie) => {
  console.log(`Getting movie details for: ${movie.eventName}`)
  const client = getClient()

  const movieInput = JSON.stringify({ ...movie, moreInfoURL: undefined, id: undefined, rawOriginHTML: undefined, imageURL: undefined })

  const response = await client.chat.completions.create({
    model,
    messages: [
      { role: 'system', content: 'You are a helpful assistant that can help me get the details of a movie. You will be given the raw movie data and must return only JSON with the following fields: title, director, year, group, when, summary. The when property must be in the format "DD/MM/YYYY HH:MM". Year should be a numeric value. All text should be in Brazilian Portuguese. In some cases, the movie details might have many short movies. In that case, return the event name as the title, director as "Vários", year as the year of the event and extract the different movies names, directors, release dates, durations from the description text and put them in the summary text.' },
      { role: 'user', content: `Dado o seguinte JSON, extraia as informações: Título do filme, diretor do filme, Data / Hora da sessão Ano do Filme Qual a mostra ou cineclube responsável. Também crie uma sinopse. Responda em formato JSON\n\n ${movieInput}` },
    ],
    response_format: { type: 'json_object' },
  })
  const responseString = response.choices?.[0]?.message.content as string | undefined
  if (!responseString) throw new Error('No response from OpenAI')

  const parsedResponse = JSON.parse(responseString)
  if (!validateMovieDetailsResponse(parsedResponse)) throw new Error('Invalid response from OpenAI: ' + responseString)
  console.log(`Movie details got for: ${movie.eventName}`)
  return parsedResponse
}

const validateMovieDetailsResponse = (response: unknown): response is { title: string; director: string; year: number; group: string; when: string; summary: string } => {
  if (typeof response !== 'object' || response === null) return false
  if (!('title' in response) || typeof response.title !== 'string') return false
  if (!('director' in response) || typeof response.director !== 'string') return false
  if (!('year' in response) || typeof response.year !== 'number') return false
  if (!('group' in response) || typeof response.group !== 'string') return false
  if (!('when' in response) || typeof response.when !== 'string') return false
  if (!('summary' in response) || typeof response.summary !== 'string') return false
  return true
}
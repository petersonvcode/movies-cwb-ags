import { readFile } from "ags/file"

type Config = {
  dbFile: string
  barTopMargin: number
  barRightMargin: number
  barPollInterval: number
  binFolder: string
}

let configSingleton: Config | null = null
export const getConfig = (configPath: string) => {
  if (!configSingleton) {
    const raw = readFile(configPath)
    configSingleton = JSON.parse(raw) as Config
    configSingleton.binFolder = configPath.replace('/config.json', '/bin')
  }
  return configSingleton
}

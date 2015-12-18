'use strict'

angular.module 'miriClientServerApp'
.filter 'traits', ->
  return (items, character) ->
    filtered = {}

    _.each items, (item) ->
      only = item.only? and item.only.length > 0
      matchesOnly = character.gender is item.only or character.race is item.only
      return if (not matchesOnly and only) or (_.contains(item.disallowed_races, character.race) or _.contains(item.disallowed_genders, character.gender))
      filtered[item.id] = item

    filtered

.filter 'trait_description', ->
  return (item, character) ->
    possessivePronoun =
      M: 'his'
      F: 'her'
      default: "it's"

    pronoun =
      M: 'he'
      F: 'she'
      default: "it"

    if character.gender is "M" or character.gender is "F" then g = character.gender else g = 'default'

    item = item.split('[PossessivePronoun]').join possessivePronoun[g]
    item = item.split('[Pronoun]').join pronoun[g]

    item = item.charAt(0).toUpperCase() + item.slice(1)
    item

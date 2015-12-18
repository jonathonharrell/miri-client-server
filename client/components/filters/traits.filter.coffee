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
    item = item.split('[PossessivePronoun]').join 'your'
    item = item.split('[Pronoun]').join 'you'
    item = item.split('[HaveHas]').join 'have'
    item = item.split('[IsAre]').join 'are'

    item = item.charAt(0).toUpperCase() + item.slice(1)
    item

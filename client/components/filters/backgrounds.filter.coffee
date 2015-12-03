'use strict'

angular.module 'miriClientServerApp'
.filter 'backgrounds', ->
  return (items, character) ->
    filtered = {}

    _.each items, (item) ->
      if item.allow_all
        filtered[item.id] = item
        return

      item.prerequisites.races             = [] if item.prerequisites.races is null
      item.prerequisites.genders           = [] if item.prerequisites.genders is null
      item.prerequisites.aesthetic_traits  = [] if item.prerequisites.aesthetic_traits is null
      item.prerequisites.functional_traits = [] if item.prerequisites.functional_traits is null

      matchesRace   = if item.prerequisites.races.length > 0 then _.contains(item.prerequisites.races, character.race) else true
      matchesGender = if item.prerequisites.genders.length > 0 then _.contains(item.prerequisites.genders, character.gender) else true

      return unless matchesRace and matchesGender

      if item.prerequisites.aesthetic_traits.length > 0
        t = []
        _.each character.aesthetic_traits, (traits) ->
          t = t.concat traits
        return if _.difference(item.prerequisites.aesthetic_traits, t).length > 0

      if item.prerequisites.functional_traits.length > 0
        t = []
        _.each character.functional_traits, (traits) ->
          t = t.concat traits
        return if _.difference(item.prerequisites.functional_traits, t).length > 0

      filtered[item.id] = item

    filtered

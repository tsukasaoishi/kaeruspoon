class AdSense
  constructor: (@ad_client) ->
    if google?
      google.load 'ads', '1'
      google.setOnLoadCallback @initPage
      @ads = {}
      $(document).on 'page:fetch', =>
        @clearAds()
      $(document).on 'page:load', =>
        @initPage()

  initPage: =>
    ad.load() for id, ad of @ads

  clearAds: ->
    @ads = {}
    window.google_prev_ad_slotnames_by_region[''] = '' if window.google_prev_ad_slotnames_by_region
    window.google_num_ad_slots = 0

  newAd: (container) ->
    options = {}
    id = 'ad_' + container.id
    w = $(window).width()
    if w > 730
      options.ad_slot = "8559817519"
      options.ad_width = 728
      options.ad_height = 90
    else if w > 360
      options.ad_slot = "5142019510"
      options.ad_width = 336
      options.ad_height = 280
    else
      options.ad_slot = "3304854312"
      options.ad_width = 300
      options.ad_height = 250
    @ads[id] = new Ad @, id, container, options

class Ad
  constructor: (@adsense, @id, @container, @options) ->

  load: ->
    if @ad_object? then @refresh() else @create()

  refresh: ->
    @ad_object.refresh()

  create: ->
    @ad_object = new google.ads.Ad @adsense.ad_client, @container, @options

window.MyAdSense = new AdSense "ca-pub-2649260317960621"

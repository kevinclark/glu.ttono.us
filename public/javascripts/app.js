var DeliciousLinks = new Class({
  Implements: Options,

  initialize: function(options) {
    this.setOptions(options)
    this.links = []
    this.loaded = false
    this.get_data()
  },

  get_data: function() {
    new JsonP(
      "http://feeds.delicious.com/v2/json/kevinclark",
      { abortAfter: 1000, retries: 1, onComplete: this.process_data.bind(this), data: { count: 3 } }
    ).request()

    return this
  },

  process_data: function(data) {
    if (this.loaded) {
      return this.links
    }
    
    this.links = data.map(function(item) {
      return {
        link: item["u"],
        name: item["d"],
        description: item["n"],
        tags: item["t"],
        created_at: Date.parse(item["dt"])
      }
    })
    
    this.loaded = true
    this.to_html()
    
    return this.links;
  },

  // TODO: Make this multiple call safe
  to_html: function() {
    box = $('click')
    clicks = new Element('dl')
    this.links.each(function(item) {
      clicks.adopt(new Element('dt', {
        html: '<a href="' + item.link + '>' + item.name + '</a>'
      }))
      clicks.adopt(new Element('dd', {
        html: item.description
      }))
    })
    box.adopt(clicks)
  }
})

window.addEvent('domready', function() { new DeliciousLinks })

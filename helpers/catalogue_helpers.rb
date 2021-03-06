module CatalogueHelpers
  def author_name
    return false if current_page.data.author_full_name.nil?
    "#{current_page.data.author_full_name}"
  end

  def location_url(entry)
    case entry[:info][:location]
    when "Taranto region"
      "#9/40.453217/17.473755"
    when "Canosa"
      "#9/41.2203553/16.0651528"
    when "Medma"
      "#9/38.487328/15.976368"
    when "South Italy"
      "#9/40.77584/15.66525"
    when "Sicily"
      "#9/37.5443/14.2816"
    end
  end

  def page_title
    if current_page.data.layout == "cover"
      "#{data.book.title.short} | #{data.book.creators.first.first_name} #{data.book.creators.first.last_name}"
    elsif current_page.data.title
      "#{current_page.data.title} | #{data.book.title.short}"
    else
      "#{site_title}"
    end
  end

  def merge_catalogue
    terracottas = []
    data.catalogue.each do |key, value|
      terracottas << value
    end

    terracottas.sort_by { |item| item[:info][:cat]  }
  end

  def collection_link(dor_id="")
    return false if dor_id == ""
    haml_tag :a, :class => "collection-link",
                 :target => "blank",
                 :title => "View this item on the Getty's collection pages.",
                 :href => "http://www.getty.edu/art/collection/objects/#{dor_id}" do
                   haml_tag :i, :class => "ion-link"
                 end
  end

  def find_in_catalogue(section=:info, key, value)
    data.catalogue.select do |cat, entry|
      entry[section][key] == value
    end
  end

  def find_discussion(entry)
    discussion_path = "discussion/" + entry[:meta][:discussion] + ".html"
    discussion = sitemap.find_resource_by_path(discussion_path)

    discussion.render(:layout => false)
      .gsub("fn:", "fn-discussion:")
      .gsub("fnref:", "fnref-discussion:")
  end

  def object_data(entry)
    rotation = 0
    rotation = 1 if entry[:meta][:rotation]

    {
      :cat        => entry[:info][:cat],
      :views      => entry[:views],
      :rotation   => rotation,
      :rheight    => entry[:meta][:rotation_height] || nil,
      :rwidth     => entry[:meta][:rotation_width] || nil,
      :dimensions => {
        :width    => main_view(entry)["pixel_width"],
        :height   => main_view(entry)["pixel_height"],
        :max_zoom => 5
      }
    }
  end

  def main_view(entry)
    entry.views.sort_by { |view| view.name }.first
  end

  def prev_page(id = 0)
    pages = sitemap.resources.find_all { |p| p.data.sort_order }
    if id == 100
      destination = "#{site_url}/catalogue/60"
      haml_tag :a, :id     => "prev-link",
                   :title  => "Previous Section",
                   :class  => "prev-link hide-on-mobile",
                   :href   => destination do
                     haml_tag :i, :class => "ion-chevron-left"
                   end
    else
      prev_page = sitemap.resources.find { |p| p.data.sort_order == id - 1 }
      return false if prev_page.nil?
      destination = "#{site_url}#{prev_page.url}"
      haml_tag :a, :id     => "prev-link",
                   :title  => "Previous Section",
                   :class  => "prev-link hide-on-mobile",
                   :href   => destination do
                     haml_tag :i, :class => "ion-chevron-left"
                   end
    end
  end

  def next_page(id = 0)
    pages = sitemap.resources.find_all { |p| p.data.sort_order }
    if id == 8
      destination = "#{site_url}/catalogue/1"
      haml_tag :a, :id     => "next-link",
                   :title  => "Next Section",
                   :class  => "next-link hide-on-mobile",
                   :href   => destination do
                     haml_tag :i, :class => "ion-chevron-right"
                   end
    else
      next_page = sitemap.resources.find { |p| p.data.sort_order == id + 1 }
      return false if next_page.nil?
      destination = "#{site_url}#{next_page.url}"
      haml_tag :a, :id     => "next-link",
                   :title  => "Next Section",
                   :class  => "next-link hide-on-mobile",
                   :href   => destination do
                     haml_tag :i, :class => "ion-chevron-right"
                   end
    end
  end

  def next_entry(id = 60)
    if id == 60
      next_page = sitemap.resources.find { |p| p.data.sort_order == 100 }
      return false if next_page.nil?
      destination = "#{site_url}#{next_page.url}"
      haml_tag :a, :id     => "next-link",
                   :title  => "Next Entry",
                   :class  => "next-link hide-on-mobile",
                   :href   => destination do
                     haml_tag :i, :class => "ion-chevron-right"
                   end
    else
      destination = "#{site_url}/catalogue/#{id + 1}/"
      haml_tag :a, :id     => "next-link",
                   :title  => "Next Entry",
                   :class  => "next-link hide-on-mobile",
                   :href   => destination do
                     haml_tag :i, :class => "ion-chevron-right"
                   end
    end
  end

  def prev_entry(id = 1)
    if id == 1
      prev_page = sitemap.resources.find { |p| p.data.sort_order == 8 }
      return false if prev_page.nil?
      destination = "#{site_url}#{prev_page.url}"
      haml_tag :a, :id     => "prev-link",
                   :title  => "Previous Entry",
                   :class  => "prev-link hide-on-mobile",
                   :href   => destination do
                     haml_tag :i, :class => "ion-chevron-left"
                   end
    else
      destination = "#{site_url}/catalogue/#{id - 1}/"
      haml_tag :a, :id     => "prev-link",
                   :title  => "Previous Entry",
                   :class  => "prev-link hide-on-mobile",
                   :href   => destination do
                     haml_tag :i, :class => "ion-chevron-left"
                   end
    end
  end
end

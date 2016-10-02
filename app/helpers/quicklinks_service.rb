class QuicklinksService
  def generate_id
    return_value = ''
    for c in 1..8
      r = rand(36)
      if r < 10
        ch = ?0.ord + r
      else
        ch = ?a.ord + (r - 10)
      end
      return_value += ch.chr
    end
    return_value
  end
  
  def generate_unique_id
    for c in 1..10
      id = generate_id
      if Quicklink.where("quicklink = ?", id).count == 0
        break
      end
    end
    id
  end

  def get_link(locations)

    ids = locations.collect{|location|
      location.id
    }.join(",")

    sql = "SELECT quicklink_id, COUNT(location_id) AS c, GROUP_CONCAT(location_id) as g FROM " +
    "(SELECT location_id, quicklink_id FROM quicklink_locations WHERE location_id IN (#{ids}))"+
    " GROUP BY quicklink_id HAVING COUNT(location_id IN (#{ids})) = #{locations.count}"

    result = Quicklink.connection.execute(sql)

    return_value = nil

    if result.count >= 1
      quicklinks = Quicklink.find(result[0]['quicklink_id'])
      if quicklinks.locations.count == result[0]['c']
        return_value = quicklinks
      else
         return_value = Quicklink.create(:quicklink => generate_unique_id)
         return_value.locations.concat(locations)
      end
    end

    return_value
  end

end
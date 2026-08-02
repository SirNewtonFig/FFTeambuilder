module StatisticsHelper
  extend Memoist

  def job_counts(event)
    characters_for(event)
      .group_by(&:job)
      .transform_values{|c| { with_skills: c.select{|x| x.primary_skills.present? }.count, without_skills: c.select{|x| x.primary_skills.blank? }.count } }
      .transform_keys(&:name)
      .sort_by{|x| x.last.values.sum }
      .reverse
  end

  def generics_by_gender(event)
    characters_for(event)
      .select(&:generic?)
      .group_by(&:job)
      .transform_values{|c| { male: c.select{|x| x.sex == 'm' }.count, female: c.select{|x| x.sex == 'f' }.count } }
      .transform_keys(&:name)
      .sort_by{|x| x.last.values.sum }
      .reverse
  end

  def secondary_counts(event)
    characters_for(event)
      .select(&:generic?)
      .select{|c| c.secondary.present? }
      .group_by(&:secondary)
      .transform_values{|c| { with_skills: c.select{|x| x.secondary_skills.present? }.count, without_skills: c.select{|x| x.secondary_skills.blank? }.count } }
      .transform_keys(&:skillset)
      .sort_by{|x| x.last.values.sum }
      .reverse
  end

  def empowers(event)
    characters_for(event)
      .select{|c| c.support.present? }
      .group_by(&:support)
      .transform_values(&:count)
      .transform_keys(&:name)
      .sort_by(&:last)
      .reverse
  end

  def reactions(event)
    characters_for(event)
      .select{|c| c.reaction.present? }
      .group_by(&:reaction)
      .transform_values(&:count)
      .transform_keys(&:name)
      .sort_by(&:last)
      .reverse
  end

  def supports(event)
    characters_for(event)
      .select{|c| c.movement.present? }
      .group_by(&:movement)
      .transform_values(&:count)
      .transform_keys(&:name)
      .sort_by(&:last)
      .reverse
  end

  def weapons(event)
    characters_for(event)
      .flat_map(&:weapons)
      .map(&:name)
      .group_by(&:itself)
      .transform_values(&:count)
      .sort_by(&:last)
      .reverse
  end

  def shields(event)
    characters_for(event)
      .filter_map(&:shield)
      .map(&:name)
      .group_by(&:itself)
      .transform_values(&:count)
      .sort_by(&:last)
      .reverse
  end

  def helmets(event)
    characters_for(event)
      .filter_map(&:helmet)
      .map(&:name)
      .group_by(&:itself)
      .transform_values(&:count)
      .sort_by(&:last)
      .reverse
  end

  def armors(event)
    characters_for(event)
      .filter_map(&:armor)
      .map(&:name)
      .group_by(&:itself)
      .transform_values(&:count)
      .sort_by(&:last)
      .reverse
  end

  def accessories(event)
    characters_for(event)
      .filter_map(&:accessory)
      .map(&:name)
      .group_by(&:itself)
      .transform_values(&:count)
      .sort_by(&:last)
      .reverse
  end

  memoize def characters_for(event)
    event.submissions.approved.flat_map do |sub|
      sub.team.characters
    end
  end

  memoize def unused_jobs(event)
    Job.where.not(name: job_counts(event).map(&:first)).load
  end

  memoize def used_skills(event)
    characters_for(event).flat_map{|c| c.rsm + c.actions }.uniq
  end

  memoize def used_items(event)
    characters_for(event).flat_map(&:items).uniq
  end

  memoize def unused_items(event, type)
    Item.where.not(id: used_items(event).map(&:id))
      .order(Arel.sql "item_type, data ->> 'memgen_id'")
      .pluck(:name, :item_type)
      .group_by(&:last)[type] || []
  end

  memoize def unused_weapons(event)
    unused_items(event, 'weapon')
      .map(&:first)
  end

  memoize def unused_shields(event)
    unused_items(event, 'shield')
      .map(&:first)
  end

  memoize def unused_helmets(event)
    unused_items(event, 'helmet')
      .map(&:first)
  end

  memoize def unused_armors(event)
    unused_items(event, 'armor')
      .map(&:first)
  end

  memoize def unused_accessories(event)
    unused_items(event, 'accessory')
      .map(&:first)
  end

  memoize def unused_skills(event, type)
    Skill.where.not(id: used_skills(event).map(&:id))
      .joins(:job)
      .order(Arel.sql "jobs.id, skills.data ->> 'memgen_id'")
      .where.not(jobs: { id: unused_jobs(event) })
      .pluck(Arel.sql 'skills.name, jobs.name, skills.skill_type')
      .group_by(&:last)[type] || []
  end

  memoize def unused_actions(event)
    unused_skills(event, 'action')
      .map{|x| x.first(2) }
  end

  memoize def unused_reactions(event)
    unused_skills(event, 'reaction')
      .map{|x| x.first(2) }
  end

  memoize def unused_empowers(event)
    unused_skills(event, 'support')
      .map{|x| x.first(2) }
  end

  memoize def unused_supports(event)
    unused_skills(event, 'movement')
      .map{|x| x.first(2) }
  end

  def chart_data(event, category, title: nil, limit: 10)
    data = send(category, event).first(limit).map{|x,y| { x:, y: }}

    {
      chart: {
        type: 'bar',
        height: 25 * data.count + 64
      },
      plotOptions: { bar: {  horizontal: true } },
      series: [{
        name: category.to_s.titleize,
        data:
      }],
      title: {
        text: title || category.to_s.titleize
      },
      tooltip: { enabled: false }
    }
  end

  def stacked_chart_data(event, category, title:, labels: [], limit: 10)
    data = send(category, event).first(limit)

    {
      chart: {
        type: 'bar',
        stacked: true,
        height: 25 * data.count + 86
      },
      plotOptions: { bar: {  horizontal: true } },
      series: labels.map.with_index{|label, i| { name: label, data: data.map{|v| v.last.values[i] } } },
      stroke: {
        width: 1,
        colors: ['#333'],
      },
      title: {
        text: title || category.to_s.titleize,
        position: ''
      },
      xaxis: {
        categories: data.map(&:first)
      },
      legend: {
        position: 'bottom',
        horizontalAlign: 'left',
        labels: { colors: ['#fff'] * labels.count }
        # offsetX: 10,
      },
      tooltip: { enabled: false }
    }
  end
end

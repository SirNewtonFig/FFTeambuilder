class Data::Import::ImportItems < ActiveInteractor::Base
  delegate :items, :itemlist, to: :context

  before_perform :setup_itemlist
  after_perform :cleanup!

  def perform
    items.each do |type, data|
      data.each do |row|
        item = Item.find_by("data ->> 'memgen_id' = ?", row['Item ID'].rjust(2, '0')) || Item.new

        itemlist << row['Item ID'].rjust(2, '0')

        item.update(
          name: row['Name'],
          item_type: type,
          data: {
            wp: row['WP'],
            w_ev: row['W-EV'],
            ev_p: row['Phys Evade'],
            ev_m: row['Magic Evade'],
            flags: row['Flags'],
            hp: row['HP'],
            mp: row['MP'],
            speed: row['Speed'],
            magic: row['MA'],
            attack: row['PA'],
            jump: row['Jump'],
            move: row['Move'],
            add: row['Adds:'],
            cancels: row['Cancels:'],
            immune: row['Immune:'],
            element: row['Element:'],
            proc: row['Proc:'],
            strengthens: row['Strengthens:'],
            always: row['Always:'],
            start: row['Start:'],
            xa: row['XA:'],
            formula: row['Formula:'],
            proc_rate: row['Proc Rate:'],
            proc_formula: row['Proc Formula:'],
            absorbs: row['Absorbs:'],
            halves: row['Halves:'],
            weakness: row['Weak:'],
            female_only: row['Classes'] == 'Female',
            memgen_id: row['Item ID'].rjust(2, '0'),
            extra_items: row['Extra Items'],
            extra_effects: row['Extra Effects:']
          }
        )

        equippable_jobs = if row['Classes'].present? && row['Classes'] !~ /not|all|any/i
          Job.generic.where(abbreviation: row['Classes'].split(' '))
        elsif row['Classes'].present? && row['Classes'] =~ /not/i
          Job.generic.where.not(name: 'Mime').where.not(abbreviation: row['Classes'].split(' ')[1..-1])
        elsif row['Classes'] =~ /all|any/i
          Job.generic.where.not(name: 'Mime')
        else
          Job.none
        end

        # April format
        equippable_jobs = equippable_jobs.or(Job.where(name: 'Mime')) unless equippable_jobs.none?

        item.job_ids = equippable_jobs.pluck(:id)
        item.skill_ids = Skill.where(name: row['Skill']).pluck(:id)
      end
    end
  end

  private

    def setup_itemlist
      context.itemlist = []
    end

    def cleanup!
      Item.where.not("data ->> 'memgen_id' IN (:ids)", ids: itemlist).destroy_all
    end
end

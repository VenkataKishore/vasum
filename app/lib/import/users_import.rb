module Import
  class UsersImport < BaseParser

    attr_accessor :error
    attr_accessor :added_count, :invalid_count, :existed_count
    attr_accessor :errors

    def initialize(file, type)
      @file = file
      @errors = []
      @type = type
      @added_count = @invalid_count = @existed_count = 0
      super(self, @file.try(:path), @type) # try, for empty file
    end

    def process
      unless @file
        @error = "#{@type} Empty"
        return false
      end

      parse
      true
    rescue ParseError
      @error = $!.message
      false
    end

    def build_obj
       User.new if @type == "only_users"
    end

    def parse
     case(@type)
       when "only_users"
         parse_users
       when "user_wise"
         parse_user_payments
       when "date_wise"
         parse_day_payments
     end
#      parse_csv_row do |row, user|
#        user.name = row[0]
#        user.mobile = row[1] if row[1].present?
#      end
    end

    ## name, mobile
    def parse_users
      parse_csv_row do |row, user|
        user.name = row[0]
        user.mobile = row[1] if row[1].present?
      end
    end

    ## name, date, amount (single day for many users)
    def parse_user_payments
      @date = ""
      i = 0
      parse_csv_row do |row|
        @date = row[2] if i == 0
        puts row[2]
        @user = User.where(name: row[0]).first
        if @user.blank?
          @invalid_count += 1
          @errors.push({title: row[0], message: "No user found!"})
        else
          @user.payments.create(paid_at: DateTime.strptime(@date, "%d/%m/%Y").strftime("%Y/%m/%d"), amount: row[1])
          @added_count += 1
        end
        i += 1
      end
    end

    ## name, date, amount (Single user on many dates)
    def parse_day_payments
      @usr = ""
      i = 0
      parse_csv_row do |row|
        if i == 0
          @usr = row[2]
          @usr = User.where(name: row[2]).first
        end
        if @usr.blank?
          @invalid_count += 1
          @errors.push({title: row[2], message: "no user found!"})
        else
          @usr.payments.create(paid_at: DateTime.strptime(row[0], "%d/%m/%Y").strftime("%Y/%m/%d"), amount: row[1])
          @added_count += 1
        end
        i += 1
      end
    end

    def push_obj(usr_obj)
      if (existed_user = User.where("name LIKE ?", "%#{usr_obj.name}%").first)
        @existed_count+= 1
      else
        if usr_obj.save
          @added_count += 1
        else
          @invalid_count += 1
          @errors.push({title: usr_obj.name,
                        message: usr_obj.errors.full_messages.join("\n")})
        end
      end
    end

  end
end

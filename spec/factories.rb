# default call to factory
#user1 = create(:user)
#user1 attributes will be username: Rspec, email: example@mail.com, password: Rspec1!!!, verification: true

# override default arguments
#user2 = create(:user, username: "Cucumber")
#user2 attributes will be username: Cucumber, email: example@mail.com, password: Rspec1!!!, verification: true

FactoryBot.define do
    factory :user do
        id              {1}
        username        {"Rspec"}
        email           {"example@mail.com"}
        password        {"Rspec1!!!"}
        verification    {true}
    end

    factory :event do
        id              {1}
        user_id         {1}
        title           {"Sagra Molinese"}
        description     {"Una buona festa"}
        start           {"Sun, 12 Jul 2020 00:00:00 +0000".to_datetime}
        ends            {"Mon, 13 Jul 2020 00:00:00 +0000".to_datetime}
        where           {"Molina Aterno, Abruzzo, Italia"}
        cords           {"42.14621,13.73623"}
        modified        {false}
    end

    factory :comment do
        id              {1}
        content         {"Nice Event!"}
        previous_id     {nil}
        user_id         {1}
        event_id        {1}
    end

end
class Steady < Sinatra::Base

    enable :sessions
        
    get '/' do

        if session[:user]
            redirect '/projects/:id'
        
        end
        slim :start
    end


    post '/login' do
        username = params['username']
        password = params['password']
        db = SQLite3::Database.open('db/projekting.db')
        id, password_hash = db.execute('SELECT id, password FROM users WHERE name = ?', username)[0]
        if id != nil
            if BCrypt::Password.new(password_hash) == password
                session[:user_id] = id
                redirect "/users/#{id}"
            end
        else
            redirect '/'
        end
        redirect '/'
    end
    
    post '/register' do
        newusername = params['username']
        newpassword = params['password']
        db = SQLite3::Database.open('db/projekting.db')
        password_hash = BCrypt::Password.create(newpassword)
        @registeruser = db.execute('INSERT INTO users (name, password) VALUES (?, ?)', [newusername, password_hash])
        redirect '/' 
    end
    
    get '/users/:id' do
        if session[:user_id] == params["id"].to_i
            id = params['id']
            db = SQLite3::Database.open ('db/projekting.db')
            @user = db.execute('SELECT name FROM users WHERE id IS ?' , id)[0][0]
            @projekts = db.execute('SELECT * FROM projekts WHERE user_id IS ?', id)
            slim :'user'
        else
            redirect '/'
        end
    end

    get '/users/:user_id/projects/:id/' do
        db = SQLite3::Database.open ('db/projekting.db')
        @todo = db.execute('SELECT * FROM')
        slim :'todd'
    end

    post '/logout' do
        redirect '/'
    end

    post '/regprojekt' do
        if session[:user_id] != nil    
            hej = params['regprojek']
            stopp = session[:user_id]
            hopp = params['duedate']
            db = SQLite3::Database.open ('db/projekting.db')
            @projektcreate = db.execute('INSERT INTO projekts (name, user_id, due_date) VALUES (?, ?, ?)', [hej, stopp, hopp])
            redirect '/projects/:id'
      #  else
       #     redirect '/'
        end
    end
end
        

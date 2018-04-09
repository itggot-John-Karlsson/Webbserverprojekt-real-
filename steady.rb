class Steady < Sinatra::Base

    enable :sessions
        
    get '/' do

        if session[:user]
            redirect '/users/:id'
        
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
            @user = db.execute('SELECT * FROM users WHERE id IS ?' , id)[0][0]
            @projekts = db.execute('SELECT * FROM projekts WHERE user_id IS ?', id)
            slim :'user'
        else
            redirect '/'
        end
    end

    get '/users/:orange/projects/:id' do
        id = params['id']
        db = SQLite3::Database.open ('db/projekting.db')
        @todo = db.execute('SELECT * FROM todo WHERE projekt_id IS ?', id)
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
            redirect '/users/:id'
        else
            redirect '/'
        end
    end
    
    post '/regtodo' do
        if session[:projekt_id] != nil    
            ro = params['projekt_id']
            bo = params['true/false']
            jo = params['todotext']
            db = SQLite3::Database.open ('db/projekting.db')
            @ctodo = db.execute('INSERT INTO todo (projekt_id, finished, text) VALUES (?, ?, ?)', [ro, bo, jo])
            redirect '/users/:orange/projects/:id'
        else
            redirect '/'
        end
    end


end
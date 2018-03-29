class Steady < Sinatra::Base

    enable :sessions

    get '/' do
        
        if session[:admin]
            @greeting = "yay"

        elsif session[:user_id]
            #@greeting = "nay"
            
            redirect '/projects/:id'
        end
        
        slim :'login'

    end

    post '/login' do
        username = params['username']
        password_from_form = params['password']
        db = SQLite3::Database.open('db/projekthantering.db')
        id, password_hash = db.execute('SELECT id, password FROM users WHERE name = ?', username)[0]
        if id != nil
            if BCrypt::Password.new(password_hash) == password_from_form
                redirect "/projects/#{id}"
            end
        else
            redirect '/'
        end
        redirect '/'
    end

    post '/logout' do
        session.destroy
        redirect '/'
    end

    post '/register' do
        reguser = params['reguser']
        regpass = params['regpass']
        db = SQLite3::Database.open('db/projekthantering.db')
        password_hash = BCrypt::Password.create(regpass)
        @sqregname = db.execute('INSERT INTO users (name, password) VALUES (?, ?)', [reguser, password_hash])
        redirect '/'
    end

    post '/projectcreate' do
        projectname = params['projectname']

    end


    get '/projects/:id' do
        id = params['id']
        db = SQLite3::Database.open('db/projekthantering.db')
        @user = db.execute('SELECT name FROM users WHERE id IS ?' , id)[0][0]
        @projects = db.execute('SELECT * FROM projects WHERE user_id IS ?', id)
        slim :'projects'
    end



end
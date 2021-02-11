class Api::V1::CheckpointsController < ApplicationController
    def index
        checkpoint = Checkpoint.all
        render json: checkpoint
    end 


    def create
        checkpoint = Checkpoint.new(checkpoint_params)
        checkpoint.image.attach(io: image_io, filename: image_name)        

        if checkpoint.save
            render json: checkpoint
        else
            render json: {error: "Unable to save checkpoint"}, status: 401
        end
    end


    def show
        checkpoint = Checkpoint.find(checkpoint_params[:id])

        if checkpoint
            render json: checkpoint
        else
            render json: {error: "Could not find the checkpoint with #{checkpoint_params[:id]}"}, status: 202
        end
    end


    private


    def checkpoint_params
        params.require(:checkpoint).permit(:trip_id, :longitude, :latitude, :description, :note, :title, :time, :date)
    end

    def image_io
        decoded_image = Base64.decode64(params[:trip][:image])
        StringIO.new(decoded_image)
    end
      
    def image_name
        params[:trip][:file_name]
    end
end

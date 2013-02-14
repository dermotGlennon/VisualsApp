package saveLoad
{
	import saveLoad.SaveLoadModel;
	import saveLoad.SaveLoadView;

	
	public class SaveLoadViewModel
	{
		/////////////////////
		//// INSTANCES //////
		/////////////////////
		
		
		/////////////////////   
		//// MEMBER VARS ////
		/////////////////////
		private var mView:SaveLoadView;
		private var mModel:SaveLoadModel;
		
		/////////////////////
		//// STATIC VARS ////
		/////////////////////
		
		public function SaveLoadViewModel(View:SaveLoadView, Model:SaveLoadModel)
		{
			mView = View;
			mModel = Model;

		}
	}
}
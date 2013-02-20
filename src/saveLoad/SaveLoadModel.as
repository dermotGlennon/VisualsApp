package saveLoad
{
	import saveLoad.SaveLoadView;
	import saveLoad.SaveLoadViewModel;
	
	public class SaveLoadModel 
	{
		/////////////////////
		//// INSTANCES //////
		/////////////////////
		
		
		/////////////////////   
		//// MEMBER VARS ////
		/////////////////////
		private var mView:SaveLoadView;
		private var mViewModel:SaveLoadViewModel;
		
		/////////////////////
		//// STATIC VARS ////
		/////////////////////
		public function SaveLoadModel(ViewModel:SaveLoadViewModel)
		{
			mViewModel = ViewModel;

		}
	}
}